USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[UpdatePADocs]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[UpdatePADocs] @parm1 VARCHAR(21) as

update ardoc set discbal = 0, curydiscbal = 0 where doctype = "PA" and batnbr in
(select batnbr from wrkrelease where module = "AR" and useraddress = @parm1)
GO
