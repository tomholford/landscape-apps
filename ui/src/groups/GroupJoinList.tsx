import React, { useCallback } from 'react';
import { useGang, useGroup, useGroupState } from '@/state/groups';
import { useLocation, useNavigate } from 'react-router';
import { getGroupPrivacy } from '@/logic/utils';
import { Link } from 'react-router-dom';
import GroupSummary, { GroupSummarySize } from './GroupSummary';

interface GroupJoinItemProps {
  flag: string;
}

function GroupJoinItem({ flag }: GroupJoinItemProps) {
  const location = useLocation();
  const navigate = useNavigate();
  const gang = useGang(flag);
  const group = useGroup(flag);
  const privacy = gang.preview?.cordon
    ? getGroupPrivacy(gang.preview?.cordon)
    : 'public';

  const open = useCallback(() => {
    if (group) {
      return navigate(`/groups/${flag}`);
    }

    return navigate(`/gangs/${flag}`, {
      state: { backgroundLocation: location },
    });
  }, [flag, group, location, navigate]);

  const reject = useCallback(() => {
    if (privacy === 'public') {
      // TODO: Liam is working on implementing the Reject Gang endpoint
      return;
    }

    navigate(`/gangs/${flag}/reject`, {
      state: { backgroundLocation: location },
    });
  }, [flag, location, navigate, privacy]);

  const join = useCallback(async () => {
    await useGroupState.getState().join(flag, true);
    navigate(`/groups/${flag}`);
  }, [flag, navigate]);

  return (
    <li className="relative flex items-center">
      <button
        className="flex w-full items-center justify-start rounded-xl p-2 text-left hover:bg-gray-50"
        onClick={open}
      >
        <GroupSummary flag={flag} {...gang.preview} size={'small'} />
      </button>
      <div className="absolute right-2 flex flex-row">
        {gang.invite ? (
          <button className="button bg-red-soft text-red" onClick={reject}>
            Reject
          </button>
        ) : null}
        <button
          className="button ml-2 bg-blue-soft text-blue"
          onClick={group ? open : join}
        >
          {group ? 'Open' : 'Join'}
        </button>
      </div>
    </li>
  );
}
interface GroupJoinListProps {
  gangs: string[];
}

interface GroupJoinListProps {
  gangs: string[];
}

export default function GroupJoinList({ gangs }: GroupJoinListProps) {
  return (
    <ul>
      {gangs.map((g) => (
        <GroupJoinItem key={g} flag={g} />
      ))}
    </ul>
  );
}
