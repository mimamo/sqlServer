USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Ed850_HeaderExt_All_CEP]    Script Date: 12/21/2015 13:56:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[Ed850_HeaderExt_All_CEP] @Parm1 varchar(10)  As select * from Ed850HeaderExt  where EDIPoId like @parm1 order by EDIPOID
GO
