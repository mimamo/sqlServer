USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDTxnType_All]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDTxnType_All]
   @FormatID	varchar(15),
   @EntryClass	varchar(4)

AS
   SELECT       *
   FROM		XDDTxnType
   WHERE	FormatID = @FormatID
   		and EntryClass LIKE @EntryClass
   ORDER BY	FormatID, EntryClass
GO
