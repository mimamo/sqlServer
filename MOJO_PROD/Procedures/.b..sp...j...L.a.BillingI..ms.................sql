USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProjectLoadBillingItems]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProjectLoadBillingItems]
	@ProjectKey int
AS --Encrypt

/*
|| When      Who Rel       What
|| 12/21/09  GWG 10.5.1.5  Added a listing of billing items that they can then change
|| 1/12/10   CRG 10.5.1.6  Modified to use the new table tWorkTypeCustom.  Still using this SP because the project get code in VB
||                         calls several SPs in a row with just the ProjectKey as a parameter, so to keep it simple, I kept this SP.
*/

	Declare @CompanyKey int

	Select @CompanyKey = CompanyKey from tProject (nolock) Where ProjectKey = @ProjectKey

	EXEC sptWorkTypeCustomGetList @CompanyKey, 'tProject', @ProjectKey
GO
