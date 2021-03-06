USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xiwValidateDonovanData]    Script Date: 12/21/2015 14:34:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xiwValidateDonovanData]
	(
        @iDonovanHdrKey         int
       ,@iValidRecordCount      int OUTPUT 
	)

AS

  -- Validate the Vendors
  UPDATE
    xiwDonovanDtl
  SET
    ImportStatus = -1
    ,ImportMsg = 'Invalid vendor'
  FROM
    xiwDonovanDtl LEFT OUTER JOIN Vendor
      ON xiwDonovanDtl.Account = Vendor.User1
  WHERE
    xiwDonovanDtl.DonovanHdrKey = @iDonovanHdrKey
    AND Vendor.VendID IS NULL

  -- Validate for the amount
  UPDATE
    xiwDonovanDtl
  SET
    ImportStatus = -2
    ,ImportMsg = 'Zero Check Amount'
  FROM
    xiwDonovanDtl 
  WHERE
    xiwDonovanDtl.DonovanHdrKey = @iDonovanHdrKey
    AND CurDebit = 0

  -- Validate for duplicate checks
  UPDATE
    T0
  SET
    ImportStatus = -3
    ,ImportMsg = 'Duplicate check'
  FROM
    xiwDonovanDtl T0 INNER JOIN xiwDonovanDtl T1
      ON T0.ChkNbr = T1.ChkNbr
  WHERE
    T0.DonovanHdrKey = @iDonovanHdrKey
    AND T1.DonovanHdrKey <> @iDonovanHdrKey 
    AND T1.ImportStatus = 1
  
  -- Validate for blank check number
  UPDATE
    xiwDonovanDtl
  SET
    ImportStatus = -4
    ,ImportMsg = 'Blank Check Number'
  FROM
    xiwDonovanDtl 
  WHERE
    xiwDonovanDtl.DonovanHdrKey = @iDonovanHdrKey
    AND ChkNbr = ''

  -- Return valid Count
  SELECT 
    @iValidRecordCount = COUNT(DonovanDtlKey)
  FROM
    xiwDonovanDtl
  WHERE
    xiwDonovanDtl.DonovanHdrKey = @iDonovanHdrKey
    AND xiwDonovanDtl.ImportStatus = 0
GO
