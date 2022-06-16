#include <iostream>
#include <string>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <stdlib.h>
#include <arpa/inet.h>
#include <string.h>

using namespace std;

int main(){

	int socketfd = 0;
	socketfd = socket(PF_INET, SOCK_STREAM, 0);

	struct sockaddr_in info = {};

	info.sin_family = PF_INET;
	info.sin_addr.s_addr = inet_addr("127.0.0.1");
	info.sin_port = htons(1234);
	
	

	int error = connect(socketfd, (struct sockaddr *)&info, sizeof(info));
	if(error == 0){
		cout<<"[Successful Connection]\n";
		
		string message;
		char recvMsg[150] = {};

		while(true){
			memset(recvMsg, 0, 149);
			read(socketfd, recvMsg, sizeof(recvMsg));
			if(!strcmp(recvMsg, "end of search")){
				break;
			}
			cout << recvMsg;

			cin >> message;
			write(socketfd, message.c_str(), message.size());
		}
		close(socketfd);
		
	}
	else {
		cout<<" *!* Connection Error, the server might be disabled. *!* \n";
	}


}