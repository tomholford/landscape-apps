/-  c=chat
|%
++  enjs
  =,  enjs:format
  |%
  ::
  ++  perm
    |=  p=perm:c
    %-  pairs
    :~  writers/a/(turn ~(tap in writers.p) (lead %s))
    ==
  ++  ship
    |=  her=@p
    n+(rap 3 '"' (scot %p her) '"' ~)
  ++  id 
    |=  =id:c
    n+(rap 3 '"' (scot %p p.id) '/' (scot %ud q.id) '"' ~)
  ::
  ++  update
    |=  =update:c
    %-  pairs
    :~  time+s+(scot %ud p.update)
        diff+(diff q.update)
    ==
  ++  diff
    |=  =diff:c
    %+  frond  -.diff
    ?+  -.diff  ~
      %writs     (writs-diff p.diff)
    ==
  ::
  ++  writs-diff
    |=  =diff:writs:c
    %-  pairs
    :~  id/(id p.diff)
        delta/(writs-delta q.diff)
    ==
  ::
  ++  writs-delta
    |=  =delta:writs:c
    %+  frond  -.delta
    ?+  -.delta  ~
      %add       (memo p.delta)
      %del       ~
      %add-feel  (add-feel +.delta)
    ==
  ++  add-feel
    |=  [her=@p =feel:c]
    %-  pairs
    :~  feel+s+feel
        ship+(ship her)
    ==
  ::
  ++  dm-action
    |=  =action:dm:c
    %-  pairs
    :~  ship+(ship p.action)
        diff+(writs-diff q.action)
    ==
  ::
  ++  memo 
    |=  =memo:c
    %-  pairs
    :~  author+(ship author.memo)
        sent+(time sent.memo)
        content+(content content.memo)
    ==
  ::
  ++  block
    |=  b=block:c
    *json
  ::
  ++  content
    |=  c=content:c
    %-  pairs
    :~  block/a/(turn p.c block)
        inline/a/(turn q.c inline)
    ==
  ::
  ++  inline
    |=  i=inline:c
    ^-  json
    ?@  i  s+i
    %+  frond  -.i
    ?-  -.i
        %break
      ~
    ::
        ?(%italics %bold %strike %inline-code)
      (inline p.i)
    ::
        ?(%code %tag)
      s+p.i
    ::
        %blockquote
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
  ++  seal
    |=  =seal:c
    %-  pairs
    :~  id+(id id.seal)
    ::
        :-  %feels
        %-  pairs
        %+  turn  ~(tap by feels.seal)
        |=  [her=@p =feel:c]
        [(scot %p her) s+feel]
    ::
        :-  %replied
        :-  %a
        (turn ~(tap in replied.seal) |=(i=id:c (id i)))
    ==
  ++  writ
    |=  =writ:c
    %-  pairs
    :~  seal+(seal -.writ)
        memo+(memo +.writ)
    ==
  ::
  ++  writ-list
    |=  w=(list writ:c)
    ^-  json
    a+(turn w writ)
  --
++  dejs
  =,  dejs:format
  |%
  ++  create
    ^-  $-(json create:c)
    %-  ot
    :~  group+flag
        name+(se %tas)
        title+so
        description+so
        readers+(as (se %tas))
    ==

  ++  ship  (su ;~(pfix sig fed:ag))
  ++  flag  (su ;~((glue fas) ;~(pfix sig fed:ag) sym))
  ++  action
    ^-  $-(json action:c)
    %-  ot
    :~  flag+flag
        update+update
    ==
  ++  dm-action
    ^-  $-(json action:dm:c)
    %-  ot
    :~  ship/ship
        diff/writs-diff
    ==
  ::
  ++  update
    |=  j=json
    ^-  update:c
    ?>  ?=(%o -.j)
    [*time (diff (~(got by p.j) %diff))]
  ::
  ++  diff
    ^-  $-(json diff:c)
    %-  of
    :~  writs/writs-diff
        add-sects/add-sects
    ==
  ::
  ++  id  
    ^-  $-(json id:c)
    %-  su 
    %+  cook  |=([p=@p q=@] `id:c`[p `@da`q])
    ;~((glue fas) ;~(pfix sig fed:ag) dem:ag)
  ::
  ++  writs-diff
    ^-  $-(json diff:writs:c)
    %-  ot
    :~  id/id
        delta/writs-delta
    ==
  ++  writs-delta
    ^-  $-(json delta:writs:c)
    %-  of
    :~  add/memo
        del/ul
        add-feel/add-feel
    ==
  ::
  ++  add-sects  (as (se %tas))
  ::
  ++  add-feel
    %-  ot
    :~  ship/ship
        feel/so
    ==
  ::
  ++  memo
    ^-  $-(json memo:c)
    %-  ot
    :~  replying/(mu id)
        author/ship
        sent/di
        content/content
    ==
  ::
  ++  content
    ^-  $-(json content:c)
    %-  ot
    :~  block/(ar block)
        inline/(ar inline)
    ==
  ::
  ++  block
    |=  j=json
    *block:c
  ::
  ++  inline
    |=  j=json
    ^-  inline:c
    ?:  ?=([%s *] j)  p.j
    =>  .(j `json`j)
    %.  j
    %-  of
    :~  italics/inline
        bold/inline
        strike/inline
        inline-code/inline
        code/so
        blockquote/(ar inline)
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
  --
--
