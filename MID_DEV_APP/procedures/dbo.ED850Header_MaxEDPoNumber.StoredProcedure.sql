USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Header_MaxEDPoNumber]    Script Date: 12/21/2015 14:17:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850Header_MaxEDPoNumber]  AS
 Select max(edipoid) from ed850header
GO
