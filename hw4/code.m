load('network_A.mat');
%load('input_test.mat')

d = zeros(100, 100);

for node_iter = 1:100 
    
    % load the current adjacency vector for node i
    link_state = A(node_iter, :); 
    % initial a array of traversed node, initially false at first
    traversed = false(1, 100); 
   
    for node_i = 1:100 
        % no direct path from node to i
        if link_state(node_i) == 0 && node_i ~= node_iter
                link_state(node_i) = intmax;
        end
    end
    
    % boolean to tell whether the loop goes on
    iteration_indicator = true;
    
    while(iteration_indicator)
        minimum_distance = intmax;
        min_d_node = node_iter;
        iteration_indicator = false;
        
        % find node_j that has shortest path to node_iter 
        for node_j = 1:100 
            if link_state(node_j) < minimum_distance && traversed(node_j) == false
                minimum_distance = link_state(node_j);
                min_d_node = node_j;
                iteration_indicator = true;
            end
        end
        
        traversed(min_d_node) = true; 
        
        % if the any node_k that is connected to the min_d_node
        % either it refreshes it's distance to node_iter or it is already
        % connected to node_iter
        for node_k = 1:100
            if A(min_d_node, node_k) == 1
                link_state(node_k) = min([link_state(min_d_node) + 1, link_state(node_k)]);
            end
        end
        
    end
    
    % the link_state for node_iter
    d(node_iter,:) = link_state;
end

%tf = isequal(in, d);

save result.mat d