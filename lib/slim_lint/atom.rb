module SlimLint
  # Represents an atomic, childless, literal value within an S-expression.
  #
  # This creates a light wrapper around literal values of S-expressions so we
  # can make an {Atom} quack like a {Sexp} without being an {Sexp}.
  class Atom
    # Creates an atom from the specified value.
    #
    # @param value [Object]
    def initialize(value)
      @value = value
    end

    # Returns whether this atom is equivalent to another object.
    #
    # This defines a helper which unwraps the inner value of the atom to compare
    # against a literal value, saving us having to do it ourselves everywhere
    # else.
    #
    # @param other [Object]
    # @return [Boolean]
    def ==(other)
      case other
      when Atom
        @value == other.instance_variable_get(:@value)
      else
        @value == other
      end
    end

    # Returns whether this atom matches the given Sexp pattern.
    #
    # This exists solely to make an {Atom} quack like a {Sexp}, so we don't have
    # to manually check the type when doing comparisons elsewhere.
    #
    # @param [Array, Object]
    # @return [Boolean]
    def match?(pattern)
      @value == pattern
    end

    # Displays the string representation the value this {Atom} wraps.
    #
    # @return [String]
    def to_s
      @value.to_s
    end

    # Displays a string representation of this {Atom} suitable for debugging.
    #
    # @return [String]
    def inspect
      "<#Atom #{@value.inspect}>"
    end

    # Redirect methods to the value this {Atom} wraps.
    #
    # Again, this is for convenience so we don't need to manually unwrap the
    # value ourselves. It's pretty magical, but results in much DRYer code.
    #
    # @param method_sym [Symbol] method that was called
    # @param args [Array]
    # @yield block that was passed to the method
    def method_missing(method_sym, *args, &block)
      if @value.respond_to?(method_sym)
        @value.send(method_sym, *args, &block)
      else
        super
      end
    end

    # Return whether this {Atom} or the value it wraps responds to the given
    # message.
    #
    # @param method_sym [Symbol]
    # @param include_private [Boolean]
    # @return [Boolean]
    def respond_to?(method_sym, include_private = false)
      if super
        true
      else
        @value.respond_to?(method_sym, include_private)
      end
    end
  end
end
