import React, { useEffect, useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { useFormContext } from 'react-hook-form';
import _ from 'lodash';
import * as DropdownMenu from '@radix-ui/react-dropdown-menu';
import { ChannelFormSchema, ChannelPrivacyType } from '@/types/groups';
import { useGroup, useRouteGroup } from '@/state/groups';
import LoadingSpinner from '@/components/LoadingSpinner/LoadingSpinner';
import CheckIcon from '@/components/icons/CheckIcon';
import XIcon from '@/components/icons/XIcon';

interface ChannelPrivacySetting {
  title: string;
  description: string;
}

export const PRIVACY_TYPE: Record<ChannelPrivacyType, ChannelPrivacySetting> = {
  public: {
    title: 'Open to All Members',
    description: 'Everyone can read and write',
  },
  'read-only': {
    title: 'Members Can Read Only',
    description: 'Only admins can write',
  },
  custom: {
    title: 'Custom',
    description: 'Specify which roles can read and write',
  },
};

interface RoleOption {
  value: string;
  label: string;
}

function RoleSelectorDropdown({
  roles,
  setRoles,
  type,
  options,
}: {
  roles: RoleOption[];
  setRoles: (r: RoleOption[]) => void;
  type: 'reader' | 'writer';
  options: RoleOption[];
}) {
  return (
    <DropdownMenu.Root>
      <DropdownMenu.Trigger asChild>
        {roles.length > 0 ? (
          <div className="flex flex-col space-y-2">
            <label className="flex flex-col space-y-1">
              <span className="text-sm text-gray-800 dark:text-gray-100">
                {type.charAt(0).toUpperCase() + type.slice(1)}s
              </span>
            </label>
            <div className="input flex items-center">
              <div className="flex flex-wrap">
                {roles.map((role) => (
                  <div
                    key={role.value}
                    className="mr-2 flex items-center justify-center rounded bg-gray-100 px-2 py-1 text-xs font-medium text-gray-800 dark:bg-gray-800 dark:text-gray-100"
                  >
                    {role.label}
                    {/*
                    <button
                      type="button"
                      className="ml-2"
                      onClick={() => {
                        setRoles(roles.filter((r) => r.value !== role.value));
                      }}
                    >
                      <XIcon className="h-4 w-4" />
                    </button>
                    */}
                  </div>
                ))}
              </div>
            </div>
          </div>
        ) : (
          <div className="flex flex-col space-y-2">
            <label className="flex flex-col space-y-1">
              <span className="text-gray-800 dark:text-gray-100">
                {type.charAt(0).toUpperCase() + type.slice(1)}s
              </span>
            </label>
            <span className="input h-9 cursor-pointer">
              Select {type} roles
            </span>
          </div>
        )}
      </DropdownMenu.Trigger>
      <DropdownMenu.Portal>
        <DropdownMenu.Content
          align="start"
          className="dropdown z-50 text-gray-800"
        >
          {options.map((option) => (
            <DropdownMenu.CheckboxItem
              key={option.value}
              className="dropdown-item relative pl-6"
              checked={roles.some((r) => r.value === option.value)}
              onSelect={(e) => {
                e.preventDefault();
              }}
              onCheckedChange={(checked) => {
                if (checked) {
                  setRoles([...roles, option]);
                } else if (option.value !== 'admin') {
                  setRoles(roles.filter((r) => r.value !== option.value));
                }
              }}
            >
              <DropdownMenu.ItemIndicator className="absolute left-0 w-6">
                <CheckIcon className="h-4 w-4" />
              </DropdownMenu.ItemIndicator>
              {option.label}
            </DropdownMenu.CheckboxItem>
          ))}
        </DropdownMenu.Content>
      </DropdownMenu.Portal>
    </DropdownMenu.Root>
  );
}

interface PrivacySettingRowProps {
  type: ChannelPrivacyType;
}

function PrivacySettingRow({ type }: PrivacySettingRowProps) {
  const { title, description } = PRIVACY_TYPE[type];
  const { register, watch } = useFormContext<ChannelFormSchema>();
  const selected = type === watch('privacy');

  return (
    <label
      className={
        'flex cursor-pointer items-center justify-between space-x-2 py-2'
      }
    >
      <div className="flex items-center">
        {selected ? (
          <div className="h-4 w-4 rounded-xl border-4 border-gray-400" />
        ) : (
          <div className="h-4 w-4 rounded-xl border-2 border-gray-200" />
        )}
      </div>
      <div className="flex w-full flex-col">
        <div className="flex flex-row items-center space-x-2">
          <div className="flex w-full flex-col justify-start text-left">
            <span className="font-semibold">{title}</span>
            <span className="text-sm font-medium text-gray-600">
              {description}
            </span>
          </div>
        </div>
      </div>
      <input
        {...register('privacy', { required: false })}
        className="sr-only"
        type="radio"
        value={type}
      />
    </label>
  );
}

export default function PrivacySelector() {
  const flag = useRouteGroup();
  const group = useGroup(flag);
  const options = group?.cabals
    ? Object.keys(group.cabals).map((c) => ({
        value: c,
        label: group.cabals[c].meta.title,
      }))
    : [];
  const { watch, setValue, getValues } = useFormContext<ChannelFormSchema>();
  const { readers, writers } = getValues();
  const [readerRoles, setReaderRoles] = useState<RoleOption[]>(
    options.filter((o) => readers.includes(o.value) || o.value === 'admin')
  );
  const [writerRoles, setWriterRoles] = useState<RoleOption[]>(
    options.filter((o) => writers.includes(o.value) || o.value === 'admin')
  );
  const custom = watch('privacy') === 'custom';

  useEffect(() => {
    if (custom) {
      setValue(
        'readers',
        readerRoles.map((r) => r.value),
        { shouldDirty: true }
      );
    } else {
      setValue('readers', [], { shouldDirty: true });
    }
  }, [readerRoles, setValue, custom]);

  useEffect(() => {
    if (custom) {
      setValue(
        'writers',
        writerRoles.map((r) => r.value),
        { shouldDirty: true }
      );
    } else {
      setValue('writers', [], { shouldDirty: true });
    }
  }, [writerRoles, setValue, custom]);

  return (
    <div className="flex flex-col space-y-4">
      <ul className="flex flex-col space-y-2">
        {Object.keys(PRIVACY_TYPE).map((type) => (
          <li key={type}>
            <PrivacySettingRow type={type as ChannelPrivacyType} />
          </li>
        ))}
      </ul>
      <AnimatePresence initial={false}>
        {custom && (
          <motion.div
            className={'flex flex-col space-y-4'}
            initial={{ opacity: 0, height: 0 }}
            animate={{ opacity: 1, height: 'auto' }}
            exit={{ opacity: 0, height: 0 }}
            transition={{ duration: 0.2 }}
          >
            <div className="text-sm text-gray-500">
              Select roles that can read and write to this channel.
            </div>
            <div className="text-sm text-gray-500">
              Readers can read all messages, writers can read and write
              messages.
            </div>
            <RoleSelectorDropdown
              roles={readerRoles}
              setRoles={setReaderRoles}
              type="reader"
              options={options}
            />
            <input value={readerRoles.map((r) => r.value)} type="hidden" />
            <RoleSelectorDropdown
              roles={writerRoles}
              setRoles={setWriterRoles}
              type="writer"
              options={options}
            />
            <input value={writerRoles.map((r) => r.value)} type="hidden" />
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
