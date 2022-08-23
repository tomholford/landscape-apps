import { AUTHORS } from '@/constants';
import { randomElement } from '@/logic/utils';
import faker from '@faker-js/faker';
import {
  Group,
  Vessel,
  Gangs,
  Gang,
  PrivacyType,
  Cordon,
  GroupIndex,
  GroupPreview,
} from '../types/groups';

const emptyVessel = (): Vessel => ({
  sects: [],
  joined: Date.now(),
});

const adminVessel = (): Vessel => ({
  sects: ['admin'],
  joined: Date.now(),
});

const randomColor = () => Math.floor(Math.random() * 16777215).toString(16);

export function makeCordon(privacy = 'public') {
  let cordon: Cordon;
  switch (privacy) {
    case 'public':
      cordon = {
        open: {
          ships: [],
          ranks: [],
        },
      };
      break;
    case 'private':
      cordon = {
        shut: [],
      };
      break;
    default:
      cordon = {
        afar: {
          app: '',
          path: '',
          desc: '',
        },
      };
      break;
  }
  return cordon;
}

export function makeGroupPreview(privacy = 'public'): GroupPreview {
  return {
    cordon: makeCordon(privacy),
    time: Date.now(),
    meta: {
      title: faker.company.companyName(),
      description: faker.company.catchPhrase(),
      image: '',
      color: `#${randomColor()}`,
    },
  };
}

export function createMockGang({
  flag,
  hasClaim = false,
  hasInvite = false,
  hasPreview = false,
  privacy = 'public',
}: {
  flag: string;
  hasClaim?: boolean;
  hasInvite?: boolean;
  hasPreview?: boolean;
  privacy?: PrivacyType;
}): Gang {
  return {
    claim: hasClaim
      ? {
          progress: 'done',
          'join-all': false,
        }
      : null,
    invite: hasInvite
      ? {
          flag,
          ship: randomElement(AUTHORS),
        }
      : null,
    preview: hasPreview ? makeGroupPreview(privacy) : null,
  };
}

export function createMockIndex(ship: string): GroupIndex {
  return {
    [`~${ship}/some-public-group`]: makeGroupPreview(),
    [`~${ship}/some-private-group`]: makeGroupPreview('private'),
    [`~${ship}/some-secret-group`]: makeGroupPreview('secret'),
  };
}

export function createMockGroup(title: string): Group {
  return {
    fleet: {
      '~hastuc-dibtux': emptyVessel(),
      '~finned-palmer': adminVessel(),
      '~zod': emptyVessel(),
    },
    cabals: {
      admin: {
        meta: {
          title: 'Admin',
          description: '',
          image: '',
          color: '',
        },
      },
      member: {
        meta: {
          title: 'Member',
          description: '',
          image: '',
          color: '',
        },
      },
    },
    channels: {},
    cordon: {
      open: {
        ranks: ['czar'],
        ships: ['~bus'],
      },
    },
    meta: {
      title,
      description:
        'We build infrastructre that is technically excellent, architecturally sound, and aesthetically beautiful',
      image:
        'https://nyc3.digitaloceanspaces.com/hmillerdev/nocsyx-lassul/2022.6.14..18.37.11-Icon Box.png',
      color: '',
    },
    zones: {
      default: {
        meta: {
          title: 'Sectionless',
          color: '',
          image: '',
          description: '',
        },
        idx: [],
      },
    },
    bloc: [],
    'zone-ord': ['default'],
  };
}
const mockGroupOne: Group = {
  fleet: {
    '~finned-palmer': emptyVessel(),
    '~zod': adminVessel(),
    '~tocref-ripmyr': emptyVessel(),
    '~hastuc-dibtux': emptyVessel(),
    '~fallyn-balfus': emptyVessel(),
    '~fabled-faster': emptyVessel(),
    '~rilfun-lidlen': emptyVessel(),
    '~nocsyx-lassul': emptyVessel(),
  },
  cabals: {
    admin: {
      meta: {
        title: 'Admin',
        description: '',
        image: '',
        color: '',
      },
    },
    member: {
      meta: {
        title: 'Member',
        description: '',
        image: '',
        color: '',
      },
    },
  },
  channels: {
    'chat/~dev/test': {
      meta: {
        title: 'Watercooler',
        description: 'watering hole',
        image: '',
        color: '',
      },
      added: 1657774188151,
      join: false,
      readers: [],
      zone: 'default',
    },
  },
  cordon: {
    open: {
      ranks: ['czar'],
      ships: ['~bus'],
    },
  },
  meta: {
    title: 'tlon',
    description: 'the tlon corporation',
    image: '',
    color: '',
  },
  zones: {
    default: {
      meta: {
        title: 'Sectionless',
        color: '',
        image: '',
        description: '',
      },
      idx: ['/chat/~dev/test'],
    },
  },
  bloc: [],
  'zone-ord': ['default'],
};

const mockGroupTwo: Group = {
  fleet: {
    '~finned-palmer': adminVessel(),
  },
  cabals: {
    admin: {
      meta: {
        title: 'Admin',
        description: '',
        image: '',
        color: '',
      },
    },
    member: {
      meta: {
        title: 'Member',
        description: '',
        image: '',
        color: '',
      },
    },
  },
  channels: {
    'chat/~zod/test': {
      meta: {
        title: 'Milady',
        description: 'Milady maker chatroom',
        image: '',
        color: '',
      },
      added: 1657774188151,
      join: true,
      readers: [],
      zone: 'default',
    },
    'heap/~zod/testHeap': {
      meta: {
        title: 'Martini Collection',
        description: 'Martini Maker Collection',
        image: '',
        color: '',
      },
      added: 1657774188151,
      join: true,
      readers: [],
      zone: 'default',
    },
  },
  cordon: {
    open: {
      ranks: ['czar'],
      ships: ['~bus'],
    },
  },
  meta: {
    title: 'remco',
    description: 'The urbit group for remilia, a digital art collective',
    image: '',
    color: '',
  },
  zones: {
    default: {
      meta: {
        title: 'Sectionless',
        color: '',
        image: '',
        description: '',
      },
      idx: ['heap/~zod/testHeap', 'chat/~zod/test'],
    },
  },
  bloc: [],
  'zone-ord': ['default'],
};

const mockGroups: { [flag: string]: Group } = {
  '~zod/remco': mockGroupTwo,
  '~dev/tlon': mockGroupOne,
};

export function createChannel(title: string) {
  return {
    meta: {
      title,
      description: 'Do some chatting',
      image: '',
      color: '',
    },
    added: 1657774188151,
    join: false,
    readers: [],
    zone: 'default',
  };
}

for (let i = 0; i < 20; i += 1) {
  const group = createMockGroup(faker.company.companyName());

  for (let j = 0; j < 20; j += 1) {
    group.channels[`/chat/~zod/tlon${i}${j}`] = createChannel(j.toString());
    group.zones.default.idx.push(`/chat/~zod/tlon${i}${j}`);
  }

  mockGroups[`~zod/tlon${i}`] = group;
}

export const mockGangs: Gangs = {
  '~zod/structure': {
    invite: {
      flag: '~zod/structure',
      ship: '~fabled-faster',
    },
    claim: {
      progress: 'adding',
      'join-all': true,
    },
    preview: {
      time: Date.now(),
      cordon: {
        afar: {
          app: '~zod/eth-verify',
          path: '/x/can-join/',
          desc: 'This group requires a',
        },
      },
      meta: {
        title: 'Structure',
        description:
          'Urbit Structural Design and Engineering Group. Always Thinking About Mechanics.',
        image:
          'https://fabled-faster.nyc3.digitaloceanspaces.com/fabled-faster/2022.1.27..17.59.43-image.png',
        color: '',
      },
    },
  },
};

export const pinnedGroups = ['~zod/remco', '~dev/tlon'];

export default mockGroups;
