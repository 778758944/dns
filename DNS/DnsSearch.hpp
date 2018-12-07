//
//  DnsSearch.hpp
//  DNS
//
//  Created by WENTAO XING on 2018/11/29.
//  Copyright © 2018 WENTAO XING. All rights reserved.
//

#ifndef DnsSearch_hpp
#define DnsSearch_hpp
#import <iostream>
#import <errno.h>
#import <stdlib.h>
#import <arpa/inet.h>
#import <sys/types.h>
#import <sys/socket.h>
#import <netdb.h>
#import <strings.h>
#define SERVER_IP "localhost"
#define SERVER_PORT "3000"

using namespace std;



class DnsSearch {
public:
    char * search(const char * domain) {
        int sock_id;
        struct addrinfo * result, dint;
        memset(&dint, 0, sizeof(dint));
        dint.ai_family = AF_INET;
        dint.ai_socktype = SOCK_DGRAM;
        
        getaddrinfo(SERVER_IP, SERVER_PORT, &dint, &result);
        
//        cout << result->ai_addr->sa_data << endl;
        cout << result->ai_addr->sa_family << endl;
//        cout << result->ai_addr->sa_len << endl;
        /*
        struct sockaddr addr = {
            .sa_len = static_cast<__uint8_t>(strlen(SERVER_IP)),
            .sa_family = AF_INET,
            .sa_data = SERVER_IP,
        };
         */
        
        sock_id = socket(PF_INET, SOCK_DGRAM, 0);
        
//        if (sock_id == -1) return;
        char msg[BUFSIZ] = "hello";
        char * buf = (char *) malloc(BUFSIZ);
        
        if (sock_id == -1) return buf;
        
        cout << domain << endl;
        long recv_len;
        
        if (sendto(sock_id, domain, strlen(domain), 0, result->ai_addr, result->ai_addrlen) == -1) {
            cout << "error occured" << endl;
        }
        
        if ((recv_len = recvfrom(sock_id, buf, BUFSIZ, 0, NULL, 0)) != -1) {
            buf[recv_len] = '\0';
        }
        
        return buf;
        
    }
};



#endif /* DnsSearch_hpp */
