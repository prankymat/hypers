
//  Copyright (c) 2016, Yuji
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  The views and conclusions contained in the software and documentation are those
//  of the authors and should not be interpreted as representing official policies,
//  either expressed or implied, of the FreeBSD Project.
//
//  Created by yuuji on 5/9/16.
//  Copyright © 2016 yuuji. All rights reserved.
#ifndef SXQueue_h
#define SXQueue_h

#include <stdio.h>
#include "SXSocket.h"
#include "SXError.h"
#include "sx_event.h"

#include <dispatch/dispatch.h>

typedef struct sx_server * SXServerRef;

SXError SXCheckStatus(sx_status_t current, sx_status_t required);

SXError SXCheckCompatibleStatus(sx_status_t current, sx_status_t * array, size_t count);

SXError SXCheckIncompatibleStatus(sx_status_t current, sx_status_t * array, size_t count);

typedef struct sx_queue
{
    sx_runtime_items;
//    sx_runtime_object_t * owner;
//    void * udata;
//    void * udata1;
//    
    __unsafe_unretained dispatch_queue_t gcd_queue;
} sx_queue_t;

typedef struct sx_queue * SXQueueRef;

SXQueueRef  SXCreateQueue   (SXSocketRef socket, dispatch_queue_t queue, SXError * err_ret);
SXError     SXFreeQueue     (SXQueueRef queue);

//SXError     SXSuspendQueue  (SXQueueRef queue);
//SXError     SXResumeQueue   (SXQueueRef queue);

#endif /* SXQueue_h */
