USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[pb_PRStdRa]    Script Date: 12/21/2015 13:44:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[pb_PRStdRa] @RI_ID SMALLINT
AS
Execute pb_PRStdRate @ri_id
GO
