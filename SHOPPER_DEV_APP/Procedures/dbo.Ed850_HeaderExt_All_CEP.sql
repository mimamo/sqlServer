USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Ed850_HeaderExt_All_CEP]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[Ed850_HeaderExt_All_CEP] @Parm1 varchar(10)  As select * from Ed850HeaderExt  where EDIPoId like @parm1 order by EDIPOID
GO
