load('network_A.mat')

% initialize empty spanning tree adjacency matrix
tree1 = zeros(100,100);

% first find node that is directly connected to the root(node 1) 
distance_to_root = A (1,:);

% create boolean array to keep track of the node in tree
InTree = false(1,100);

% the root is guaranteed in tree
InTree(1) = true;

% initialize shotest path to root for every node
node_to_reach_root = zeros(1,100);


for i = 2:100
    if distance_to_root(i) == 0
        distance_to_root(i) = intmax;
    else
        node_to_reach_root(i) = 1;
    end
end


for i = 2:100
   minimum_distance = intmax;
   index_w_min_d = 0;
   for j = 2:100
       if (distance_to_root(j) < minimum_distance) && (InTree(j) == false)
           minimum_distance = distance_to_root(j);
           index_w_min_d = j;
       end
   end
  
   InTree(index_w_min_d) = true;
   tree1(node_to_reach_root(index_w_min_d), index_w_min_d) = 1;
   tree1(index_w_min_d, node_to_reach_root(index_w_min_d)) = 1;
   
   
    for k = 1:100
        if A(index_w_min_d, k) == 1
            if(distance_to_root(index_w_min_d) + 1 ) < distance_to_root(k)
                distance_to_root(k) = distance_to_root(index_w_min_d) + 1;
                node_to_reach_root(k) = index_w_min_d;
            end
        end

    end   
end


tf = isequal(tree, tree1);


