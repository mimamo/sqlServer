USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_1031_Item2Hist]    Script Date: 12/21/2015 13:45:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_1031_Item2Hist]  @siteid varchar(10), @invtid varchar(30),@fiscyr char(6) as      
select * from item2Hist where 
siteid = @siteid 
and invtid = @invtid
and fiscyr = @fiscyr
order by siteid
GO
