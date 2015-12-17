USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARHist_spk0]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[ARHist_spk0]  @parm1 varchar (15) , @parm2 varchar (4) , @parm3 varchar (10) as
select * from ARHist
where CustId = @parm1 and
FiscYr = @parm2 and
Cpnyid = @parm3
order by CustId
GO
