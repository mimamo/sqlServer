USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10510]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10510]
AS

	exec spConvertDBSeed
	exec spConvertDBRefreshViews

	--Convert contact work addresses
	DECLARE @AddressKey int,
			@UserKey int

	SELECT	@UserKey = -1
	
	WHILE(1=1)
	BEGIN
		SELECT	@UserKey = MIN(u.UserKey)
		FROM	tUser u (nolock)
		INNER JOIN tAddress a (nolock) ON u.AddressKey = a.AddressKey AND a.Entity IS NULL
		WHERE	u.UserKey > @UserKey
		
		IF @UserKey IS NULL
			BREAK
		
		SELECT @AddressKey = AddressKey from tUser (nolock) Where UserKey = @UserKey
				
		UPDATE	tUser
		SET		LinkedCompanyAddressKey = @AddressKey
		WHERE	UserKey = @UserKey
		
		INSERT	tAddress
				(OwnerCompanyKey,
				Entity,
				EntityKey,
				AddressName,
				Address1,
				Address2,
				Address3,
				City,
				State,
				PostalCode,
				Country,
				Active)
		SELECT	u.OwnerCompanyKey,
				'tUser',
				u.UserKey,
				'Personal Work',
				a.Address1,
				a.Address2,
				a.Address3,
				a.City,
				a.State,
				a.PostalCode,
				a.Country,
				a.Active
		FROM	tAddress a (nolock)
		INNER JOIN tUser u (nolock) ON a.AddressKey = u.AddressKey
		WHERE	u.UserKey = @UserKey
		
		UPDATE	tUser
		SET		AddressKey = @@IDENTITY
		WHERE	UserKey = @UserKey

	END
GO
