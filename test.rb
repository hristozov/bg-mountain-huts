# encoding: utf-8
require 'mongoid'

require "./model/map_object"
require "./model/hut"
require "./model/shelter"
require "./model/user"
require 'digest/sha1'

ENV['MONGOID_ENV'] = "development"


Mongoid.load!("mongoid.yml")

#Shelter.create({name: "Плачковица", lat: 24.11, lng: 56.22})
#Hut.create({name: "Рай", lat: 25.11, lng: 52.22})
#Hut.create({name: "Левски", lat: 26.11, lng: 57.22})
User.delete_all
User.create({email: "hristozov@gmail.com", password:(Digest::SHA1.hexdigest 'foo')})

