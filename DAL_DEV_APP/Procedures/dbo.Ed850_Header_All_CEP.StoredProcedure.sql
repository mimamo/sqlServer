USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Ed850_Header_All_CEP]    Script Date: 12/21/2015 13:35:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[Ed850_Header_All_CEP] @Parm1 varchar(10),@parm2 varchar(10)  As select * from Ed850Header  where cpnyid = @parm1 and EDIPoId like @parm2 order by EDIPOID
GO
