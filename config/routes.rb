Rails.application.routes.draw do
  get 'fit/:width/:height/:image' => 'images#fit'
  get 'max/:width/:image' => 'images#max_width'
end
