#include <iostream>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <string.h>
#include <vector>
#include <fstream>
using namespace std;


int main() {
    
    // database preprocessing
    vector<string> keys;
    vector<string> emails;

    // readfile from query.txt
    ifstream infile("query.txt");
    
    // while the file isn't reminated
    // since the original text file is sorted.
    // we can input studentID and email sequentially into 2 list
    // and we can map student ID to email as 1 to 1 correspondance hashing
    while(!infile.eof()) {
        string tempKey, tempEmail;
        infile >> tempKey >> tempEmail;
        keys.push_back(tempKey);
        emails.push_back(tempEmail);
    }
    infile.close();
    
    
    
    // socket address initialization
    struct sockaddr_in myAddr;
    struct sockaddr_in client_addr;

    // basket socket setup
    myAddr.sin_family = PF_INET;	
    myAddr.sin_port = htons(1234);	            // port 1234
    myAddr.sin_addr.s_addr = htonl(INADDR_ANY); 
    int sockfd = socket (PF_INET, SOCK_STREAM, 0);	
    int streamfd = 0;
    bind (sockfd, (struct sockaddr *) &myAddr, sizeof(struct sockaddr_in));	
    listen (sockfd, 10);	

    


    // infinite server state
    while(true){
        
        // setup for connection stage
        unsigned int addr_size = sizeof(client_addr);	
        int status = 0; // define initial status as 0
        streamfd = accept(sockfd, (struct sockaddr*)&client_addr, &addr_size);	
        char inputBuffer[256] = {};
        
        while(true) {
            //status in initial status
            if(!status) {
                memset(inputBuffer, 0, 255);
                char tempBuffer[] = {"What's your requirement? 1.DNS 2.QUERY 3.QUIT : "};
			    write(streamfd, tempBuffer, sizeof(tempBuffer));
		        status = 100;
            }

            // 100 indicates in selection stage
            else if (status == 100) {
                // read the selection from the streamfd to 
                // a self create inputBuffer
                read(streamfd, inputBuffer, 255);
                string inputSelection(inputBuffer);
                string selectionResult = "";

                if(inputSelection == "1") {
                    selectionResult = "Input URL address : ";
                    status = 1;
                }

                else if (inputSelection == "2") {
                    selectionResult = "Input student ID : ";
                    status = 2;
                }

                else if(inputSelection == "3") {
                    selectionResult = "end of search";
                    status = 3;
                }

                else {
                    selectionResult = "Invalid request (only support 1.DNS, 2.QUERY, 3.QUIT)\n\n";
                    status = 0;
                }
                write(streamfd, selectionResult.c_str(), selectionResult.size());
            }

            /* status control */
            /*************************************************************************************************************************/
            /* case 1 */
            else if(status == 1){
				read(streamfd, inputBuffer, 255);
				string response = "address get from domain name : ";
				struct hostent* host = {}; 
                host = gethostbyname(inputBuffer);
                if(host == NULL){
                        std::cout << "*!* No such address to be found. *!*\n";  //client side message
                        response += "No such DNS";
                }

                else {
                    char* addr;
                    for(auto ptr = host->h_addr_list; *ptr != NULL; ptr++){
                            addr = inet_ntoa(*((struct in_addr*)(*ptr)));
                            std::cout << addr << "\n";
                    }
				
                    response += string(addr);
                }
				response += "\n\n";
				write(streamfd, response.c_str(), response.size());
				status = 0;
			}

            /* case 2 */
			else if(status == 2){
			    read(streamfd, inputBuffer, 255);
				string key(inputBuffer);
				string response = "Email get from server : ";
                bool foundData = false;

                for(int i = 0; i < keys.size(); i++){
                    if(key == keys[i]){
                        cout << "[found at server]\n";
                        foundData = true;
                        response += emails[i];
                        break;
                    }   
                }
                
                if(!foundData){
                    cout << "*!* not found at server *!* \n";
                    response += "No such student ID";
				}

				response += "\n\n";
				write(streamfd, response.c_str(), response.size());
				status = 0;
			}

            /* case 3 */
			else if(status == 3){
				cout << "disconnect\n";
				status = 0;
				break;
			}
        }
        close(streamfd);	
    }
}

