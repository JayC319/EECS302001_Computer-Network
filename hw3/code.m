load('network_A.mat')

% initialize a minimal spanning tree
tree = zeros(100,100);

% initialize that every node think itself is the root 
root_recognize = zeros(1,100);
for i =1:100
    root_recognize(i) = i;
end

% since every node think itself is the root,
% every initial node's hop to root is 0
hops_to_root = zeros(1,100);

% initial next hop to root
next_hop_to_root = (2147483647 * ones(1,100));

% create a boolean array to keep track whether the node is in the tree now
InTree = false(1,100);
InTree(1) = true;

% create a integer to keep track if the edge has increase to vertex - 1
% in this case is 100 - 1 = 99
edge = 0;

% first uses BFS to find the node that is surrounding the root
direct_link_to_root = A(1,:);
queue_for_BFS = []; % empty queue
BFS_index = 1;      % index to append to queue

for count=2:100
    if(direct_link_to_root(count) == 1)
        InTree(count) = 1;
        edge = edge + 1;
        queue_for_BFS(BFS_index) = count;
        BFS_index = BFS_index + 1;
        
        root_recognize(count) = 1;
        next_hop_to_root(count) = 1;
        hops_to_root(count) = 1;
        tree(1,count) = 1;
        tree(count,1) = 1;
    end
end

% queue to store next layer BFS node
next_level_BFS_queue = [];
next_level_BFS_index = 1;

% the tree will be build up when the edge number is 99 = 100 - 1
while(edge < 99)     

% start with the smaller numbered node
queue_for_BFS = sort(queue_for_BFS);

for current_layer_index = 1:(BFS_index-1)
    for node_for_next_layer_BFS = 2:100
        if A(queue_for_BFS(current_layer_index), node_for_next_layer_BFS) == 1
           
            % cases when the node in next layer recognize larger root
            if(InTree(node_for_next_layer_BFS) == 0 && root_recognize(queue_for_BFS(current_layer_index)) < root_recognize(node_for_next_layer_BFS))
                % the root the next layer node now recognize the node that
                % is the current inQueue node
                root_recognize(node_for_next_layer_BFS) = root_recognize(queue_for_BFS(current_layer_index));
               
                % next hop to the root of the next layer node is the
                % current inQueue node
                next_hop_to_root(node_for_next_layer_BFS) = queue_for_BFS(current_layer_index);
                
                % update the hop count to the root
                hops_to_root(node_for_next_layer_BFS) = hops_to_root(queue_for_BFS(current_layer_index)) + 1;
                tree(queue_for_BFS(current_layer_index), node_for_next_layer_BFS) = 1;
                tree(node_for_next_layer_BFS, queue_for_BFS(current_layer_index)) = 1;
                next_level_BFS_queue(next_level_BFS_index) = node_for_next_layer_BFS;
                next_level_BFS_index = next_level_BFS_index + 1;
                InTree(node_for_next_layer_BFS) = 1;
                edge = edge + 1;
            
            % cases when the node in the next layer recognize same root
            %but the hop to next node is larger
            elseif(hops_to_root(node_for_next_layer_BFS)-1 > hops_to_root(queue_for_BFS(current_layer_index)))
                % unlink the edge
                tree(node_for_next_layer_BFS, next_hop_to_root(node_for_next_layer_BFS)) = 0;
                tree(next_hop_to_root(node_for_next_layer_BFS), node_for_next_layer_BFS) = 0;
                
                % refresh the hop count
                hops_to_root(node_for_next_layer_BFS) = hops_to_root(queue_for_BFS(current_layer_index)) + 1;
                
                % link the new edge
                next_hop_to_root(node_for_next_layer_BFS) = queue_for_BFS(current_layer_index);
                tree(queue_for_BFS(current_layer_index), node_for_next_layer_BFS) = 1;
                tree(node_for_next_layer_BFS, queue_for_BFS(current_layer_index)) = 1;
            end
        end
    end 
end

% assign the next layer to current layer
queue_for_BFS = next_level_BFS_queue;
BFS_index = next_level_BFS_index;
   

end
save result.mat tree

