USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[UpdatePADocs]    Script Date: 12/21/2015 13:45:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[UpdatePADocs] @parm1 VARCHAR(21) as

update ardoc set discbal = 0, curydiscbal = 0 where doctype = "PA" and batnbr in
(select batnbr from wrkrelease where module = "AR" and useraddress = @parm1)
GO
