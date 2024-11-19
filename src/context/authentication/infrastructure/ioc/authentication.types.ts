export const AUTHENTICATION_TYPES = {
	AuthenticationService: Symbol.for("AuthenticationService"),
	AuthenticationController: Symbol.for("AuthenticationController"),
	AuthenticationProvider: Symbol.for("AuthenticationProvider"),
	AuthenticationMiddleware: Symbol.for("AuthenticationMiddleware"),
	BcryptManager: Symbol.for("BcryptManager"),
	UserRepository: Symbol.for("UserRepository"),
};
