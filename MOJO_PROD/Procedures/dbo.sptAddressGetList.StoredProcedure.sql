USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAddressGetList]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAddressGetList]
	(
		@CompanyKey INT
		,@Entity VARCHAR(50)		-- Pass NULL for a company's address
		,@EntityKey INT			
		,@Active TINYINT			-- Pass NULL if Active/Inactive needed
		,@AddressKey INT			-- Can be NULL, if address is inactive, it will still be added to the list
	)
AS	-- Encrypt

  /*
  || When       Who Rel      What
  || 02/04/2009 MFT 10.0.1.8 (45900) Escape the procedure when @CompanyKey = 0 and @Entity is NULL
  || 09/23/09   GWG 10.5.1.1 Modified the get for users so that it is just based on entity and entity key
  */

	SET NOCOUNT ON 
	
	
	/*
	OwnerCompanyKey only used for Company backup and delete
	
						Main Company	Client/Vendor	tUser (Employee)	tUser (Client)
	OwnerCompanyKey		100				100				100					100
	CompanyKey			100				352				100					352
	Entity				NULL			NULL			'tUser'				'tUser'
	EntityKey			NULL			NULL			567					1278
	
	*/
	
	IF @Entity IS NULL AND @CompanyKey = 0
	
		RETURN
	
	ELSE IF @Entity IS NULL
	
		IF @AddressKey IS NULL
			SELECT *
			FROM   tAddress (NOLOCK)
			WHERE  CompanyKey = @CompanyKey
			AND    Entity IS NULL
			AND    (@Active IS NULL OR Active = @Active)
		ELSE
			SELECT *
			FROM   tAddress (NOLOCK)
			WHERE  CompanyKey = @CompanyKey
			AND    Entity IS NULL
			AND    ((@Active IS NULL OR Active = @Active) OR AddressKey = @AddressKey) 
		
	ELSE
	
		IF @AddressKey IS NULL
			SELECT *
			FROM   tAddress (NOLOCK)
			WHERE  Entity = @Entity	
			AND    EntityKey = @EntityKey
			AND    EntityKey > 0
			--AND    CompanyKey = @CompanyKey
			AND    (@Active IS NULL OR Active = @Active)
		ELSE
			SELECT *
			FROM   tAddress (NOLOCK)
			WHERE  Entity = @Entity	
			AND    EntityKey = @EntityKey
			AND    EntityKey > 0
			--AND    CompanyKey = @CompanyKey
			AND    ((@Active IS NULL OR Active = @Active) OR AddressKey = @AddressKey) 
		
		
	RETURN
GO
