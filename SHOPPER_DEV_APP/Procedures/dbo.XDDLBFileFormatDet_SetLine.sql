USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDLBFileFormatDet_SetLine]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDLBFileFormatDet_SetLine]
   @FormatID	varchar(15)

AS
   SELECT       FieldEnd,
    		FieldNbr,
    		FieldStart,
    		FieldType
   FROM         XDDLBFileFormatDet (nolock)
   WHERE        FormatID = @FormatID
   ORDER BY     FormatID, FieldNbr
GO
