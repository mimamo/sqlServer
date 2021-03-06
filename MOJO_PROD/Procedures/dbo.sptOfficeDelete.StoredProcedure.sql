USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptOfficeDelete]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptOfficeDelete]
	@OfficeKey int

AS --Encrypt

  /*
  || When     Who Rel        What
  || 12/05/07 GHL  8.5       Added check of other tables                 
  || 07/23/14 WDF 10.5.8.2   Added specific return numbers                 
  */
  
If exists(Select 1 from tProject (nolock) Where OfficeKey = @OfficeKey) 
	return -1
If exists(Select 1 from tMediaEstimate (nolock) Where OfficeKey = @OfficeKey) 
	return -2	

If exists(Select 1 from tClass (nolock) Where OfficeKey = @OfficeKey)
	return -3
If exists(Select 1 from tUser (nolock) Where OfficeKey = @OfficeKey)
	return -4
	
If exists(Select 1 from tBilling (nolock) Where OfficeKey = @OfficeKey)
	return -5
If exists(Select 1 from tInvoice (nolock) Where OfficeKey = @OfficeKey)
	return -6	
If exists(Select 1 from tVoucher (nolock) Where OfficeKey = @OfficeKey)
	return -7	

If exists(Select 1 from tTransaction (nolock) Where OfficeKey = @OfficeKey)
	return -8


	DELETE
	FROM tOffice
	WHERE
		OfficeKey = @OfficeKey 

	RETURN 1
GO
