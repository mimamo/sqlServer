USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Header_MaxEDPoNumber]    Script Date: 12/21/2015 15:42:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850Header_MaxEDPoNumber]  AS
 Select max(edipoid) from ed850header
GO
