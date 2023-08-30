/-  d=diary, e=epic
|=  =vase
|^  ^-  state-2
    =+  !<([old=versioned-state cool=epic:e] vase)
    |-
    ?-  -.old
      %0  $(old (state-0-to-1 old))
      %1  $(old (state-1-to-2 old))
      %2  old
    ==
::
+$  versioned-state  $%(state-0 state-1 state-2)
+$  state-0
  $:  %0
      shelf=shelf:zero
      voc=(map [flag:zero plan:zero] (unit said:zero))
      imp=(map flag:zero ?)
  ==
+$  state-1
  $:  %1
      =shelf:one
      voc=(map [flag:one plan:one] (unit said:one))
      imp=(map flag:one ?)
  ==
+$  state-2
  $:  %2
      =shelf:d
      voc=(map [flag:d plan:d] (unit said:d))
  ==
++  zero  zero:old:d
++  one   one:old:d
++  two   d
++  state-0-to-1
  |=  s=state-0
  ^-  state-1
  %*  .  *state-1
    shelf  (shelf-0-to-1 shelf.s)
    voc    voc.s
    imp    imp.s
  ==
::
++  shelf-0-to-1
  |=  old-shelf=shelf:zero
  ^-  shelf:one
  %-  malt
  %+  turn
    ~(tap by old-shelf)
  |=  [=flag:one old-diary=diary:zero]
  ^-  [flag:one diary:one]
  [flag [~ old-diary]]
::
++  state-1-to-2
  |=  s=state-1
  ^-  state-2
  %*  .  *state-2
    shelf  (shelf-1-to-2 shelf.s)
    voc    voc.s
  ==
::
++  shelf-1-to-2
  |=  old-shelf=shelf:one
  ^-  shelf:two
  %-  ~(run by old-shelf)
  |=  =diary:one
  ^-  diary:two
  %*  .  *diary:two
    notes   (notes-1-to-2 notes.diary)
    order   [%0 arranged-notes.diary]
    view    [%0 view.diary]
    sort    [%0 sort.diary]
    perm    [%0 perm.diary]
    net     !!
    log     (log-1-to-2 diary)
    remark  remark.diary
    window  *window:two
    future  *future:two
  ==
::
++  notes-1-to-2
  |=  old=notes:one
  ^-  notes:two
  %-  ~(run by old)
  |=  =note:one
  `(note-1-to-2 note)
::
++  note-1-to-2
  |=  old=note:one
  ^-  note:two
  :_  [%0 +.old]
  -.old(quips (quips-1-to-2 quips.old), feels (feels-1-to-2 feels.old))
::
++  quips-1-to-2
  |=  old=quips:one
  ^-  quips:two
  %-  ~(run by old)
  |=  =quip:one
  `(quip-1-to-2 quip)
::
++  quip-1-to-2
  |=  old=quip:one
  ^-  quip:two
  [-.old(feels (feels-1-to-2 feels.old)) +.old]
::
++  feels-1-to-2
  |=  old=(map ship feel:one)
  ^-  feels:two
  %-  ~(run by old)
  |=  =feel:one
  [%0 `feel]
::
++  log-1-to-2
  |=  old-diary=diary:one  ::NOTE  because we need the perm also
  ^-  log:two
  %+  gas:log-on:two  *log:two
  %+  murn  ~(tap by log.old-diary)
  |=  [=time =diff:one]
  =;  new=(unit u-diary:two)
    (bind new (lead time))
  ?-    -.diff
      ?(%add-sects %del-sects)  `[%perm 0 perm.old-diary]
      %create                   `[%create p.diff]
      %view                     `[%view 0 p.diff]
      %sort                     `[%sort 0 p.diff]
      %arranged-notes           `[%order 0 p.diff]
      %notes
    =-  ?~(- ~ `[%note p.p.diff -])
    ^-  (unit u-note:two)
    =/  old-note  (get:on:notes:one notes.old-diary p.p.diff)
    ?-    -.q.p.diff
        ?(%add %edit)           `[%set (bind old-note note-1-to-2)]
        %del                    `[%set ~]
        ?(%add-feel %del-feel)
      ?~  old-note  ~
      `[%feels (feels-1-to-2 feels.u.old-note)]
    ::
        %quips
      ?~  old-note  ~
      =*  diff-quip  p.q.p.diff
      =-  ?~(- ~ `[%quip p.diff-quip -])
      ^-  (unit u-quip:two)
      =/  old-quip  (get:on:quips:one quips.u.old-note p.diff-quip)
      ?-    -.diff-quip
          %add  `(unit u-quip:two)``[%set (bind old-quip quip-1-to-2)]
          %del  `(unit u-quip:two)``[%set ~]
          ?(%add-feel %del-feel)
        ^-  (unit u-quip:two)
        ?~  old-quip  ~
        `[%feels (feels-1-to-2 feels.u.old-quip)]
      ==
    ==
  ==
--
