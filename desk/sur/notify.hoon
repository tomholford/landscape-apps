/-  resource
|%
+$  provider-action
  $%  [%add service=term notify=@t binding=@t auth-token=@t =whitelist]
      [%remove service=term]
      [%client-join service=term address=@t binding=@t]
      [%client-leave service=term]
  ==
::
+$  client-action
  $%  [%connect-provider who=@p service=term address=@t]
      [%connect-provider-with-binding who=@p service=term address=@t binding=@t]
      [%remove-provider who=@p service=term]
  ==
::
+$  uid  @uvH
::
++  notification
  =<  note
  |%
  +$  note     [=bin =body]
  +$  bin      [=path =place]
  +$  place    [=desk =path]
  +$  body     [title=content =content =time binned=path link=path]
  +$  content  (list $%([%ship =ship] [%cord =cord]))
  --
::
+$  whitelist
  $:  public=?
      kids=?
      users=(set ship)
      groups=(set resource:resource)
  ==
::
+$  action  ?(%notify %dismiss)
::
+$  update
  [=uid =action]
--
