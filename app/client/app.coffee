# Client-side Code

# Bind to socket events
SS.socket.on 'disconnect', ->
	SS.client.util.message "サーバー","接続が切断されました。"
SS.socket.on 'reconnect', ->
	SS.client.util.message "サーバー","接続が回復しました。"

# This method is called automatically when the websocket connection is established. Do not rename/delete

my_userid=null

exports.init = ->
  	# 固定リンク
	$("a").live "click", (je)->
		t=je.target
		return if je.isDefaultPrevented()
		return if t.target=="_blank"
		je.preventDefault()

		SS.client.app.showUrl t.href
		return
		
	if localStorage.userid && localStorage.password
		login localStorage.userid, localStorage.password,(result)->
			if result
				p = location.pathname
				if p=="/" then p="/my"		
			else
				#p="/"
				# 無効
				localStorage.removeItem "userid"
				localStorage.removeItem "password"
			showUrl p
	else
		showUrl location.pathname
	window.addEventListener "popstate",(e)->
		# location.pathname
		showUrl location.pathname,true
  
exports.page=page=(templatename,params=null,pageobj,startparam)->
	cdom=$("#content").get(0)
	jQuery.data(cdom,"end")?()
	jQuery.removeData cdom,"end"
	$("#content").empty()
	$("##{templatename}").tmpl(params).appendTo("#content")
	if pageobj
		pageobj.start(startparam)
		jQuery.data cdom, "end", pageobj.end

exports.showUrl=showUrl=(url,nohistory=false)->
	if result=url.match /(https?:\/\/.+?)(\/.+)$/
		if result[1]=="#{location.protocol}//#{location.host}" #location.origin
			url=result[2]
		else
			location.href=url
	
	switch url
		when "/my"
			# プロフィールとか
			SS.server.user.myProfile (user)->
				page "templates-user-profile",user,SS.client.user.profile,null
		when "/rooms"
			# 部屋一覧
			page "templates-game-rooms",null,SS.client.game.rooms, null
		when "/rooms/log"
			# 終わった部屋
			page "templates-game-rooms",null,SS.client.game.rooms,"log"
		when "/newroom"
			# 新しい部屋
			page "templates-game-newroom",null,SS.client.game.newroom,null
		when "/lobby"
			# ロビー
			page "templates-lobby",null,SS.client.lobby,null
		when "/manual"
			# マニュアルトップ
			page "templates-manual-top",null,SS.client.manual,null
		when "/admin/blacklist"
			# アク禁
			page "templates-admin-blacklist",null,SS.client.admin.blacklist,null
		else
			if result=url.match /^\/room\/(\d+)$/
				# ルーム
				page "templates-game-game",null,SS.client.game.game,parseInt result[1]
			else if result=url.match /^\/user\/(\w+)$/
				# ユーザー
				page "templates-user-view",null,SS.client.user.view,result[1]
			else if result=url.match /^\/manual\/job\/(\w+)$/
				# ジョブ情報
				win=SS.client.util.blankWindow()
				$("#templates-jobs-#{result[1]}").tmpl().appendTo win
				return
			else if result=url.match /^\/manual\/(\w+)$/
				page "templates-manual-#{result[1]}",null,SS.client.manual,null
			else
				page "templates-top",null,SS.client.top,null
				SS.server.user.logout ->
					my_userid=null
					localStorage.removeItem "userid"
					localStorage.removeItem "password"
	unless nohistory
		history.pushState null,null,url
					
					
exports.refresh=->showUrl location.pathname,true

exports.login=login=(uid,ups,cb)->
	SS.server.user.login {userid:uid,password:ups},(result)->
		if !result
			# OK
			my_userid=uid
			$("#username").text uid
			cb? true
		else
			cb? false
exports.userid=->my_userid

