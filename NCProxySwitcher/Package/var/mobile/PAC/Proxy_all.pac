function regExpMatch(url, pattern) {
	try { return new RegExp(pattern).test(url); } catch(ex) { return false; }
}

function FindProxyForURL(url, host) {
	return 'PROXY 127.0.0.1:808';
}
