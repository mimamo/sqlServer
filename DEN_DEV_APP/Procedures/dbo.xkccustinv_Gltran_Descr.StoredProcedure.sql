USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xkccustinv_Gltran_Descr]    Script Date: 12/21/2015 14:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkccustinv_Gltran_Descr] @refnbr varchar(10), @fromkey varchar(15), @tokey varchar(15)  as
declare @numrecs int
SELECT @numrecs =  count(*) from gltran where 
refnbr = @refnbr
and trandesc like '%'+@fromkey+'%'
if @numrecs > 0 
    BEGIN
	update gltran set trandesc = replace(trandesc,@fromkey, @tokey) where refnbr = @refnbr and trandesc like '%'+@fromkey+'%'
    end
select @numrecs
GO
