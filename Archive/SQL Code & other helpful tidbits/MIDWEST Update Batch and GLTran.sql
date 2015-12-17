-- Update all of the batches

select * from Batch where Rlsed = 0 and module = 'GL' and status = 'P' 

update Batch
set Rlsed = 1 
where Rlsed = 0 and module = 'GL' and status = 'P' 


-- Update all GL tranactions
select * from gltran where Rlsed = 0 and module = 'GL' and Posted = 'P' 

update gltran 
set Rlsed = 1 
where Rlsed = 0 and module = 'GL' and Posted = 'P' 