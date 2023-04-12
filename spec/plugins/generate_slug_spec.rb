require 'spec_helper'

describe Sequel::Plugins::GenerateSlug do
  before do
    DB.create_table :assets do
      primary_key :id
      String :name
      String :identifier
      String :slug
    end

    class Asset < Sequel::Model(:assets)
      plugin :generate_slug, source: :name, additional: :identifier
    end
  end

  after do
    DB.drop_table :assets
  end

  describe 'before_create' do
    context 'when slug is not provided' do
      it 'generates unique slug' do
        asset = Asset.create(name: 'Test Asset', identifier: '123')
        expect(asset.slug).not_to be_empty
      end
    end

    context 'when slug is provided' do
      it 'does not override provided slug' do
        asset = Asset.create(name: 'Test Asset', identifier: '123', slug: 'test-asset')
        expect(asset.slug).to eq('test-asset')
      end
    end
  end

  describe 'before_update' do
    context 'when source or additional columns are modified' do
      it 'updates slug' do
        asset = Asset.create(name: 'Test Asset', identifier: '123')
        asset.update(name: 'New Name')
        expect(asset.slug).to eq('new-name')
      end
    end

    context 'when slug column is modified' do
      it 'does not update slug' do
        asset = Asset.create(name: 'Test Asset', identifier: '123')
        asset.update(slug: 'updated-asset')
        expect(asset.slug).to eq('updated-asset')
      end
    end
  end
end
