USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCHARGD_SPK1]    Script Date: 12/21/2015 15:49:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCHARGD_SPK1]  @parm1 varchar (10)   as
select * from PJCHARGD
where    batch_id    = @parm1
order by batch_id,
detail_num
GO
