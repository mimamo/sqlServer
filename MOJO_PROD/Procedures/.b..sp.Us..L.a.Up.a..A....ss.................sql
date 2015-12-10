USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserLeadUpdateAddress]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserLeadUpdateAddress]
	(
		@UserLeadKey int,
		@AddressKey int,
		@HomeAddressKey int,
		@OtherAddressKey int
	)
		
AS


Update tUserLead
Set
	AddressKey = @AddressKey,
	HomeAddressKey = @HomeAddressKey,
	OtherAddressKey = @OtherAddressKey
Where UserLeadKey = @UserLeadKey
GO
