import _ from 'lodash';
import {
  QueryKey,
  useQuery,
  useQueryClient,
  UseQueryOptions,
} from '@tanstack/react-query';
import { useEffect, useRef } from 'react';
import api from '@/api';
import useSchedulerStore from '@/state/scheduler';

export default function useReactQuerySubscription<T, Event = null>({
  queryKey,
  app,
  path,
  scry,
  scryApp = app,
  priority = 3,
  onEvent,
  options,
}: {
  queryKey: QueryKey;
  app: string;
  path: string;
  scry: string;
  scryApp?: string;
  priority?: number;
  onEvent?: (data: Event) => void;
  options?: UseQueryOptions<T>;
}) {
  const queryClient = useQueryClient();
  const invalidate = useRef(
    _.debounce(
      () => {
        queryClient.invalidateQueries(queryKey);
      },
      300,
      { leading: true, trailing: true }
    )
  );

  const fetchData = async () =>
    useSchedulerStore.getState().wait(async () => {
      console.log('scrying', scryApp, scry);
      return api.scry<T>({
        app: scryApp,
        path: scry,
      });
    }, priority);

  useEffect(() => {
    api.subscribe({
      app,
      path,
      event: onEvent ? onEvent : invalidate.current,
    });
  }, [app, path, queryClient, queryKey, onEvent]);

  return useQuery(queryKey, fetchData, {
    staleTime: 60 * 1000,
    ...options,
  });
}
