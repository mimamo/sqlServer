USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Ed850_HeaderExt_All_CEP]    Script Date: 12/21/2015 14:17:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[Ed850_HeaderExt_All_CEP] @Parm1 varchar(10)  As select * from Ed850HeaderExt  where EDIPoId like @parm1 order by EDIPOID
GO
