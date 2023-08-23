/-  d=diary
/-  meta
/+  cite=cite-json, gj=groups-json
|%
++  enjs
  =,  enjs:format
  |%
  ++  said
    |=  s=said:d
    ^-  json
    %-  pairs
    :~  flag/(flag p.s)
        outline/(outline q.s)
    ==
  ++  outline
    |=  o=outline:d
    %-  pairs
    :~  title/s/title.o
        image/s/image.o
        content/a/(turn content.o verse)
        author+(ship author.o)
        sent+(time sent.o)
        'quipCount'^(numb quips.o)
        quippers/a/(turn ~(tap in quippers.o) ship)
        type/s/%outline
    ==
  ::
  ++  outlines
    |=  os=outlines:d
    %-  pairs
    %+  turn  (tap:on:outlines:d os)
    |=  [t=@da o=outline:d]
    ^-  [cord json]
    [(scot %ud t) (outline o)]
  ::
  ++  quips-delta
    |=  d=delta:quips:d
    %+  frond  -.d
    ?-  -.d
      %add  (memo p.d)
      %del  ~
      %add-feel  (add-feel +.d)
      %del-feel  (ship p.d)
    ==
  ::
  ++  flag
    |=  f=flag:d
    ^-  json
    s/(rap 3 (scot %p p.f) '/' q.f ~)
  ::
  ++  ship
    |=  her=@p
    n+(rap 3 '"' (scot %p her) '"' ~)
  ::
  ++  briefs
    |=  bs=briefs:d
    %-  pairs
    %+  turn  ~(tap by bs)
    |=  [f=flag:d b=brief:briefs:d]
    [(rap 3 (scot %p p.f) '/' q.f ~) (brief b)]
  ::
  ++  brief-update
    |=  u=update:briefs:d
    %-  pairs
    :~  flag/(flag p.u)
        brief/(brief q.u)
    ==
  ::
  ++  brief
    |=  b=brief:briefs:d
    %-  pairs
    :~  last/(time last.b)
        count/(numb count.b)
        read-id/?~(read-id.b ~ (time u.read-id.b))
    ==
  ::
  ++  shelf
    |=  sh=shelf:d
    %-  pairs
    %+  turn  ~(tap by sh)
    |=  [f=flag:d di=diary:d]
    [(rap 3 (scot %p p.f) '/' q.f ~) (diary di)]
  ::
  ++  arranged-notes
    |=  a=arranged-notes:d
    :-  %a
    =/  times=(list ^time)  ?~(a ~ u.a)
    %+  turn
      times
    |=  t=^time
    s/(scot %ud t)
  ::
  ++  create
    |=  =create:d
    %-  pairs
    :~  group+(flag group.create)
        title+s+title.create
        description+s+description.create
        readers+a+(turn ~(tap in readers.create) (lead %s))
        writers+a+(turn ~(tap in writers.create) (lead %s))
    ==
  ::
  ++  diary
    |=  di=diary:d
    %-  pairs
    :~  arranged-notes/(arranged-notes arranged-notes.di)
        perms/(perm perm.di)
        view/s/view.di
        sort/s/sort.di
        saga/(saga net.di)
    ==
  ++  saga
    |=  n=net:d
    ?-  -.n
      %pub  ~
      %sub  (saga:enjs:gj saga.n)
    ==
  ++  perm
    |=  p=perm:d
    %-  pairs
    :~  writers/a/(turn ~(tap in writers.p) (lead %s))
        group/(flag group.p)
    ==
  ++  flag-action
    |=  [=flag:d =action:d]
    %-  pairs
    :~  flag/(^flag flag)
        action/(^action action)
    ==
  ++  update
    |=  =update:d
    %-  pairs
    :~  time+s+(scot %ud time.update)
        diff+(diff diff.update)
    ==
  ++  action
    |=  =action:d
    %+  frond  -.action
    ?+  -.action  (diff-inner action)
      %create     (create create.action)
      %join       (flag group.action)
      %leave      ~
      %read       ~
      %read-at    s+(scot %ud time.action)
      %watch      ~
      %unwatch    ~
    ==
  ::
  ++  diff
    |=  dif=diff:d
    (frond -.dif (diff-inner dif))
  ::
  ++  diff-inner
    |=  dif=diff:d
    ?-  -.dif
        %view         s/view.dif
        %sort         s/sort.dif
        %create       (create create.dif)
        %order        (arranged-notes notes.dif)
        %notes        (notes-diff id.dif delta.dif)
        %add-writers  a/(turn ~(tap in sects.dif) (lead %s))
        %del-writers  a/(turn ~(tap in sects.dif) (lead %s))
    ==
  ::
  ++  notes-diff
    |=  [=id:notes:d =command:notes:d]
    %-  pairs
    :~  id/s/(scot %ud id)
        command/(notes-delta command)
    ==
  ::
  ++  notes-delta
    |=  =delta:notes:d
    %+  frond  -.delta
    ?-  -.delta
        %add       (essay p.delta)
        %edit      (essay p.delta)
        %del       ~
        %add-feel  (add-feel +.delta)
        %del-feel  (ship p.delta)
        %quips
      %-  pairs
      :~  id+s+(scot %ud id.delta)
          command+(quips-delta command.delta)
      ==
    ==
  ::
  ++  essay
    |=  =essay:d
    %-  pairs
    :~  title/s/title.essay
        image/s/image.essay
        content/a/(turn content.essay verse)
        author+(ship author.essay)
        sent+(time sent.essay)
    ==
  ::
  ++  verse
    |=  =verse:d
    ^-  json
    %+  frond  -.verse
    ?-  -.verse
        %block  (block p.verse)
        %inline  a+(turn p.verse inline)
    ==
  ++  block
    |=  b=block:d
    ^-  json
    %+  frond  -.b
    ?-  -.b
        %rule  ~
        %cite  (enjs:cite cite.b)
        %listing  (listing p.b)
        %header
      %-  pairs
      :~  tag+s+p.b
          content+a+(turn q.b inline)
      ==
        %image
      %-  pairs
      :~  src+s+src.b
          height+(numb height.b)
          width+(numb width.b)
          alt+s+alt.b
      ==
        %code
      %-  pairs
      :~  code+s+code.b
          lang+s+lang.b
      ==
    ==
  ::
  ++  listing
    |=  l=listing:d
    ^-  json
    %+  frond  -.l
    ?-  -.l
        %item  a+(turn p.l inline)
        %list
      %-  pairs
      :~  type+s+p.l
          items+a+(turn q.l listing)
          contents+a+(turn r.l inline)
      ==
    ==
  ::
  ++  inline
    |=  i=inline:d
    ^-  json
    ?@  i  s+i
    %+  frond  -.i
    ?-  -.i
        %break
      ~
    ::
        %ship  s/(scot %p p.i)
    ::
        ?(%code %tag %inline-code)
      s+p.i
    ::
        ?(%italics %bold %strike %blockquote)
      :-  %a
      (turn p.i inline)
    ::
        %block
      %-  pairs
      :~  index+(numb p.i)
          text+s+q.i
      ==
    ::
        %link
      %-  pairs
      :~  href+s+p.i
          content+s+q.i
      ==
    ==
  ::
  ++  add-feel
    |=  [her=@p =feel:d]
    %-  pairs
    :~  feel+s+feel
        ship+(ship her)
    ==
  ::
  ++  notes
    |=  =notes:d
    ^-  json
    %-  pairs
    %+  turn  (tap:on:notes:d notes)
    |=  [key=@da n=note:d]
    [(scot %ud key) (note n)]
  ::
  ++  quips
    |=  =quips:d
    ^-  json
    %-  pairs
    %+  turn  (tap:on:quips:d quips)
    |=  [key=@da q=quip:d]
    [(scot %ud key) (quip q)]
  ::
  ++  quip
    |=  q=quip:d
    ^-  json
    %-  pairs
    :~  cork+(cork -.q)
        memo+(memo +.q)
    ==
  ++  story
    |=  s=story:d
    ^-  json
    %-  pairs
    :~  block/a/(turn p.s block)
        inline/a/(turn q.s inline)
    ==
  ::
  ++  memo
    |=  m=memo:d
    ^-  json
    %-  pairs
    :~  content/(story content.m)
        author/(ship author.m)
        sent/(time sent.m)
    ==
  ::
  ++  note
    |=  =note:d
    %-  pairs
    :~  seal+(seal -.note)
        essay+(essay +.note)
        type/s/%note
    ==
  ::
  ++  cork
    |=  =cork:d
    %-  pairs
    :~  time+(time time.cork)
    ::
        :-  %feels
        %-  pairs
        %+  turn  ~(tap by feels.cork)
        |=  [her=@p =feel:d]
        [(scot %p her) s+feel]
    ==

  ::
  ++  seal
    |=  =seal:d
    %-  pairs
    :~  time+(time time.seal)
    ::
        :-  %quips
        %-  pairs
        %+  turn  (tap:on:quips:d quips.seal)
        |=  [t=@da q=quip:d]
        [(scot %ud t) (quip q)]
    ::
        :-  %feels
        %-  pairs
        %+  turn  ~(tap by feels.seal)
        |=  [her=@p =feel:d]
        [(scot %p her) s+feel]
    ==
  ::
  ++  remark-action
    |=  action=$>(?(%read %read-at %watch %unwatch) action:d)
    %+  frond  -.action
    ~!  -.action
    ?-  -.action
      %read-at  (time time.action)
      ?(%read %watch %unwatch)  ~
    ==
  ::
  --
++  dejs
  =,  dejs:format
  |%
  ++  ship  (su ;~(pfix sig fed:ag))
  ++  flag  `$-(json flag:d)`(su flag-rule)
  ++  flag-rule  ;~((glue fas) ;~(pfix sig fed:ag) sym)
  ++  create
    ^-  $-(json create:d)
    %-  ot
    :~  group+flag
        title+so
        description+so
        readers+(as (se %tas))
        writers+(as (se %tas))
    ==
  ++  flag-action
    ^-  $-(json flag-action:d)
    %-  ot
    :~  flag+flag
        action+action
    ==
  ++  action
    ^-  $-(json action:d)
    %-  of
    :~  create+create
        join+flag
        leave+ul
        read+ul
        read-at+(se %ud)
        watch+ul
        unwatch+ul
      ::
        notes+notes-diff
        view+(su (perk %grid %list ~))
        sort+(su (perk %time %alpha %arranged ~))
        order+(mu (ar (se %ud)))
        add-writers+add-sects
        del-writers+del-sects
    ==
  ::
  ++  command
    ^-  $-(json command:d)
    %-  of
    :~  notes/notes-diff
        view/(su (perk %grid %list ~))
        sort/(su (perk %time %alpha %arranged ~))
        order/(mu (ar (se %ud)))
        add-writers/add-sects
        del-writers/del-sects
    ==
  ::
  ++  quips-diff
    %-  ot
    :~  id/(se %ud)
        command/quips-delta
    ==
  ::
  ++  quips-delta
    %-  of
    :~  add/memo
        del/ul
        add-feel/add-feel
        del-feel/ship
    ==
  ::
  ++  story
    %-  ot
    :~  block/(ar block)
        inline/(ar inline)
    ==
  ::
  ++  memo
    %-  ot
    :~  content/story
        author/(se %p)
        sent/di
    ==
  ::
  ++  notes-diff
    ^-  $-(json [id:notes:d command:notes:d])
    %-  ot
    :~  id/(se %ud)
        command/notes-delta
    ==
  ++  notes-delta
    ^-  $-(json delta:notes:d)
    %-  of
    :~  add/essay
        edit/essay
        del/ul
        quips/quips-diff
        add-feel/add-feel
        del-feel/ship
    ==
  ::
  ++  add-sects  (as (se %tas))
  ::
  ++  del-sects  (as so)
  ::
  ++  essay
    ^-  $-(json essay:d)
    %-  ot
    :~  title/so
        image/so
        content/(ar verse)
        author/ship
        sent/di
    ==
  ::
  ++  verse
    ^-  $-(json verse:d)
    %-  of
    :~  block/block
        inline/(ar inline)
    ==
  ::
  ++  block
    |=  j=json
    ^-  block:d
    %.  j
    %-  of
    :~  rule/ul
        cite/dejs:cite
        listing/listing
    ::
      :-  %code
      %-  ot
      :~  code/so
          lang/(se %tas)
      ==
    ::
      :-  %header
      %-  ot
      :~  tag/(su (perk %h1 %h2 %h3 %h4 %h5 %h6 ~))
          content/(ar inline)
      ==
    ::
      :-  %image
      %-  ot
      :~  src/so
          height/ni
          width/ni
          alt/so
      ==
    ==
  ::
  ++  listing
    |=  j=json
    ^-  listing:d
    %.  j
    %-  of
    :~
      item/(ar inline)
      :-  %list
      %-  ot
      :~  type/(su (perk %ordered %unordered ~))
          items/(ar listing)
          contents/(ar inline)
      ==
    ==
  ::
  ++  inline
    |=  j=json
    ^-  inline:d
    ?:  ?=([%s *] j)  p.j
    =>  .(j `json`j)
    %.  j
    %-  of
    :~  italics/(ar inline)
        bold/(ar inline)
        strike/(ar inline)
        blockquote/(ar inline)
        ship/ship
        inline-code/so
        code/so
        tag/so
        break/ul
    ::
      :-  %block
      %-  ot
      :~  index/ni
          text/so
      ==
    ::
      :-  %link
      %-  ot
      :~  href/so
          content/so
      ==
    ==
  ::
  ++  add-feel
    %-  ot
    :~  ship/ship
        feel/so
    ==
  ::
  ++  remark-action
    %-  ot
    :~  flag/flag
        diff/remark-diff
    ==
  ::
  ++  remark-diff
    %-  of
    :~  read/ul
        watch/ul
        unwatch/ul
    ==
  --
--
