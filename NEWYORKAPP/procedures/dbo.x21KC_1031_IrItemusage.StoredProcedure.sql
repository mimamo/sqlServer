USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_1031_IrItemusage]    Script Date: 12/21/2015 16:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_1031_IrItemusage]  @siteid varchar(10), @invtid varchar(30),@period char(6) as      
select * from irItemUsage where 
siteid = @siteid 
and invtid = @invtid
and period = @Period
order by siteid
GO
