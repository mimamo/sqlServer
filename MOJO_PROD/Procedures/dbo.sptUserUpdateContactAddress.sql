USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserUpdateContactAddress]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserUpdateContactAddress]
	(
		@UserKey int,
		@AddressKey int,
		@HomeAddressKey int,
		@OtherAddressKey int
	)
		
AS


Update tUser
Set
	AddressKey = @AddressKey,
	HomeAddressKey = @HomeAddressKey,
	OtherAddressKey = @OtherAddressKey
Where UserKey = @UserKey
GO
