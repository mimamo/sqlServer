USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDTxnTypeDep_EStatus_List]    Script Date: 12/21/2015 13:45:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDTxnTypeDep_EStatus_List]
   @VendID	varchar(15)

AS

   declare @EStatusList			varchar(255)
   
   -- Default the value
   SET		@EStatusList = ' ;SL Check'
   
   if exists(Select * from XDD_vp_TxnTypeDep Where VendCust = 'V' and VendID = @VendID)
   BEGIN
   	   SET		@EStatusList = ''
   	   
	   SELECT       @EStatusList = @EStatusList + EStatus + ';' + rtrim(DescrShort) + ','
	   FROM			XDD_vp_TxnTypeDep
	   WHERE		VendCust = 'V'
	   				and VendID = @VendID
	   				and Selected = 1
	   ORDER BY	EStatus

	   if len(@EStatusList) > 0
	   	SET	@EStatusList = left(@EStatusList, len(@EStatusList) - 1)
   END
   
   SELECT	@EStatusList
GO
