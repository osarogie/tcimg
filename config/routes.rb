Rails.application.routes.draw do
  root 'images#index'
  get 'fit/:width/:height/:image' => 'images#fit'
  get 'max/:width/:image' => 'images#max_width'
end
