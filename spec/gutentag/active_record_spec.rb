require 'spec_helper'

describe Gutentag::ActiveRecord do
  describe '.in_tag' do
    let!(:melborne_article) do
      article = Article.create title: 'Overview'
      article.tag_names << 'melborne'
      article.save!
      article
    end

    let!(:oregon_article) do
      article = Article.create
      article.tag_names << 'oregon'
      article.save!
      article
    end

    let!(:melborne_oregon_article) do
      article = Article.create
      article.tag_names = %w(oregon melborne)
      article.save!
      article
    end

    context 'given a single tag name' do
      subject { Article.in_tag('melborne') }

      it { expect(subject.count).to eq 2 }
      it { is_expected.to include melborne_article, melborne_oregon_article }
      it { is_expected.not_to include oregon_article }
    end

    context 'given a single tag name[symbol]' do
      subject { Article.in_tag(:melborne) }

      it { expect(subject.count).to eq 2 }
      it { is_expected.to include melborne_article, melborne_oregon_article }
      it { is_expected.not_to include oregon_article }
    end

    context 'given multiple tag names' do
      subject { Article.in_tag('melborne', 'oregon') }

      it { expect(subject.count).to eq 3 }
      it { is_expected.to include melborne_article, oregon_article, melborne_oregon_article }
    end

    context 'given an array of tag names' do
      subject { Article.in_tag(%w(melborne oregon)) }

      it { expect(subject.count).to eq 3 }
      it { is_expected.to include melborne_article, oregon_article, melborne_oregon_article }
    end

    context 'given a single tag instance' do
      subject { Article.in_tag(Gutentag::Tag.find_by_name('melborne')) }

      it { expect(subject.count).to eq 2 }
      it { is_expected.to include melborne_article, melborne_oregon_article }
      it { is_expected.not_to include oregon_article }
    end

    context 'given multiple tag objects' do
      subject { Article.in_tag(Gutentag::Tag.where(name: %w(melborne oregon))) }

      it { expect(subject.count).to eq 3 }
      it { is_expected.to include melborne_article, oregon_article, melborne_oregon_article }
    end

    context 'chaining where clause' do
      subject { Article.in_tag(%w(melborne oregon)).where(title: 'Overview') }

      it { expect(subject.count).to eq 1 }
      it { is_expected.to include melborne_article }
      it { is_expected.not_to include oregon_article, melborne_oregon_article }
    end
  end
end
