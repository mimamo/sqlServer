USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDLBFileFormatDet_SetLine]    Script Date: 12/21/2015 15:43:14 ******/
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
