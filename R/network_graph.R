network_graph <- function(features){
  nodes <-
    features %>%
    tidyr::pivot_longer(dplyr::everything(), values_to = 'node', names_to = 'type') %>%
    dplyr::distinct(type, node) %>%
    dplyr::bind_rows(
      #list(type = 'centre', node = '001'),
      .
    ) %>%
    dplyr::arrange(node) %>%
    dplyr::mutate(node_id =  as.numeric(factor(node)) - 1,
                  type_num = as.numeric(factor(type)) - 1,
                  node_size = c(50,5)[type_num + 1])

  links <-
    features %>%
    dplyr::arrange(name) %>%
    dplyr::bind_rows(
      #data.frame(name = '001',mgenres = unique(features$genres)),
      .
    ) %>%
    dplyr::mutate(node_id = as.numeric(factor(name, levels = levels(factor(nodes$node)))) - 1,
                  genres_id = as.numeric(factor(genres, levels = levels(factor(nodes$node)))) - 1,
                  value = ifelse(name == '001', 1, 2))


  networkD3::forceNetwork(Links = links,
                          Nodes = nodes,
                          Source = 'node_id',
                          Target = 'genres_id',
                          Value = 'value',
                          NodeID = 'node',
                          Group = 'type_num',
                          Nodesize = 'node_size',
                          linkDistance = JS('d => d.value'),
                          colourScale = JS("d3.scaleOrdinal(d3.schemeCategory10);"),
                          opacity = 0.8,
                          charge = -150,
                          bounded = TRUE,
                          legend = TRUE,
                          fontSize = 24)
}
