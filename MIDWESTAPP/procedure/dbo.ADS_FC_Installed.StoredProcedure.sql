USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADS_FC_Installed]    Script Date: 12/21/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADS_FC_Installed]
AS
	-- Force to uninstalled until FCSetup table is added to the schema
	select	0

	--select  count(*) > 0
	--	then 1
	--	else 0
	--	end
	--from	FCSetup (nolock)
GO
