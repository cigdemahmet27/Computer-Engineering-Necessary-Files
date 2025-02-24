#include "tree.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

TreeNode *init_node(GameState *gs)
{
  TreeNode *tree = (TreeNode*) malloc(sizeof(TreeNode));
  tree->num_children = -1;
  tree->game_state = gs;
  tree->children = NULL;

  return tree;
}

// Given a game state, construct the tree up to the given depth using the available moves for each node
// Returns the root node
// You can assume that depth >= 2


TreeNode *init_tree(GameState *gs, int depth)
{
  TreeNode *root = init_node(gs);

  depth--;
  while(depth)
  {
    expand_tree(root);
    depth--;
  }
  
  return root;
}

// Frees the tree
void free_tree(TreeNode *root)
{
  if(!root)
  {
    for(int i = 0; i < root->num_children; i++)
    {
      free_tree(root->children[i]);
    }
    free(root->children);
    free_game_state(root->game_state);
    free(root);
  }
}

// Expand all leaf nodes of the tree by one level

void expand_tree(TreeNode *root) 
{
  
  if(root->num_children > 0)
  {
    for(int i = 0; i < root->num_children; i++)
    {
      expand_tree(root->children[i]);
    }
  } else if(get_game_status(root->game_state) == IN_PROGRESS) 
  {

      bool moves[root->game_state->width];
      memset(moves, false, root->game_state->width * sizeof(bool));
      int mv = available_moves(root->game_state, moves); // we get the number of moves;
      
      if(mv == 0)
        return;
      
      root->num_children = mv;
      root->children = (TreeNode**)malloc(sizeof(TreeNode*) * mv);

      int j = 0;
      for(int i = 0; i < root->game_state->width; i++)
      {
        if(moves[i]) {
          root->children[j] = init_node(make_move(root->game_state, i));
          j++;
        }
      }  
  }
  return;
}

// Count the number of nodes in the tree 
int node_count(TreeNode *root)
{
  int counter = 1;
  if(root->num_children != -1)
  {
    for(int i = 0; i < root->num_children; i++)
    {
      counter += node_count(root->children[i]);
    }
  }
  return counter;
}

// Print the tree for debugging purposes (optional)
void print_tree(TreeNode *root, int level);

