USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xPJTran_PJTranEx_all]    Script Date: 12/21/2015 14:18:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[xPJTran_PJTranEx_all] @parm1 varchar (16)  as
select a.*, b.* from PJTran a inner join
pjtranex b on a.fiscalno = b.fiscalno and
			  a.system_cd = b.system_cd and
			  a.batch_id = b.batch_id and 
			  a.detail_num = b.detail_num

where a.project like @parm1
order by project
GO
