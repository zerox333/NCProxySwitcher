function regExpMatch(url, pattern) {
	try { return new RegExp(pattern).test(url); } catch(ex) { return false; }
}

function FindProxyForURL(url, host) {
	if(shExpMatch(host, 'localhost')) return 'DIRECT';
	if(shExpMatch(host, '127.0.0.1')) return 'DIRECT';
	if(shExpMatch(host, '<local>')) return 'DIRECT';
	return 'PROXY 127.0.0.1:808';
}
