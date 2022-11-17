import _ from 'lodash';
import React, { useEffect } from 'react';
import { Outlet, useNavigate, useParams } from 'react-router';
import { Helmet } from 'react-helmet';
import cn from 'classnames';
import ChatInput from '@/chat/ChatInput/ChatInput';
import ChatWindow from '@/chat/ChatWindow';
import Layout from '@/components/Layout/Layout';
import { ViewProps } from '@/types/groups';
import { useChatPerms, useChatState, useMessagesForChat } from '@/state/chat';
import {
  useRouteGroup,
  useVessel,
  useGroup,
  useChannel,
  useAmAdmin,
  GROUP_ADMIN,
} from '@/state/groups/groups';
import ChannelHeader from '@/channels/ChannelHeader';
import { createStorageKey } from '@/logic/utils';
import { useLocalStorage } from 'usehooks-ts';

function ChatChannel({ title }: ViewProps) {
  const navigate = useNavigate();
  const { chShip, chName } = useParams();
  const chFlag = `${chShip}/${chName}`;
  const nest = `chat/${chFlag}`;
  const groupFlag = useRouteGroup();
  const amAdmin = useAmAdmin(groupFlag);
  const [, setRecent] = useLocalStorage(
    createStorageKey(`recent-chan:${groupFlag}`),
    ''
  );

  useEffect(() => {
    useChatState.getState().initialize(chFlag);
    setRecent(nest);
  }, [chFlag, nest, setRecent]);

  const messages = useMessagesForChat(chFlag);
  const perms = useChatPerms(chFlag);
  const vessel = useVessel(groupFlag, window.our);
  const canWrite =
    perms.writers.length === 0 ||
    _.intersection(perms.writers, vessel.sects).length !== 0;
  const { sendMessage } = useChatState.getState();

  const channel = useChannel(groupFlag, nest);
  const group = useGroup(groupFlag);

  useEffect(() => {
    if (channel?.readers.includes(GROUP_ADMIN) && !amAdmin) {
      navigate('../activity');
      setRecent('');
    }
  }, [channel, amAdmin, navigate, setRecent]);

  return (
    <Layout
      className="flex-1 bg-white"
      aside={<Outlet />}
      header={<ChannelHeader flag={groupFlag} nest={nest} />}
      footer={
        <div className={cn(canWrite ? 'border-t-2 border-gray-50 p-4' : '')}>
          {canWrite ? (
            <ChatInput whom={chFlag} sendMessage={sendMessage} showReply />
          ) : null}
        </div>
      }
    >
      <Helmet>
        <title>
          {channel && group
            ? `${channel.meta.title} in ${group.meta.title} ${title}`
            : title}
        </title>
      </Helmet>
      <ChatWindow whom={chFlag} messages={messages} />
    </Layout>
  );
}

export default ChatChannel;
