USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJALERT_spk0]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJALERT_spk0]  @parm1 varchar (4) , @parm2beg smallint , @parm2end smallint   as
select * from PJALERT
where   alert_group_cd     =  @parm1 and
alert_id  between  @parm2beg and @parm2end
order by alert_group_cd, alert_id
GO
